--德莱姆的挑战者
function c65060018.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),2,3,c65060018.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,65060018)
	e1:SetCost(c65060018.spcost)
	e1:SetTarget(c65060018.sptg)
	e1:SetOperation(c65060018.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c65060018.atkcon)
	e2:SetOperation(c65060018.atkop)
	c:RegisterEffect(e2)
end

function c65060018.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x6da4)
end

function c65060018.spcosfil(c)
	return c:IsSetCard(0x6da4) and c:IsAbleToGraveAsCost()
end

function c65060018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060018.spcosfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	local g=Duel.SelectMatchingCard(tp,c65060018.spcosfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c65060018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end

function c65060018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end

function c65060018.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local lg=e:GetHandler():GetLinkedGroup()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and a:GetControler()~=d:GetControler() and ((a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_LIGHT) and a:IsRace(RACE_FAIRY) and a:IsRelateToBattle() and lg:IsContains(a))
		or (d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_LIGHT) and d:IsRace(RACE_FAIRY) and d:IsRelateToBattle() and lg:IsContains(d))or (a==e:GetHandler() and a:IsRelateToBattle()) or (d==e:GetHandler() and d:IsRelateToBattle()))
end

function c65060018.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	if a:GetControler()==tp then
		e1:SetValue(d:GetAttack())
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetAttack())
		d:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TURN_END)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCountLimit(1)
	e2:SetOperation(c65060018.adop)
	if a:GetControler()==tp then
		a:RegisterEffect(e2)
	else
		d:RegisterEffect(e2)
	end
end
function c65060018.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local tc=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetBaseAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1,true)
	e:Reset()
end