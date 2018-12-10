--Answer·渋谷凛·Triad
c81010064.dfc_front_side=81010064
c81010064.dfc_back_side=81010065
c81010064.card_code_list={81010019}
function c81010064.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetValue(81010019)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81010064)
	e2:SetCondition(c81010064.defcon)
	e2:SetOperation(c81010064.defop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,81010064)
	e3:SetCondition(c81010064.spcon)
	e3:SetTarget(c81010064.sptg)
	e3:SetOperation(c81010064.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function c81010064.defcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	e:SetLabelObject(d)
	return a:IsControler(1-tp) and d and d:IsType(TYPE_RITUAL) and d:IsType(TYPE_MONSTER) and d:IsControler(tp) and d~=e:GetHandler()
end
function c81010064.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
	end
end
function c81010064.cfilter(c,tp)
	return bit.band(c:GetPreviousCodeOnField(),81010019)~=0 and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousLevelOnField()>6
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c81010064.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return eg:IsExists(c81010064.cfilter,1,nil,tp)
end
function c81010064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81010064.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local c=e:GetHandler()
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
	end
end
