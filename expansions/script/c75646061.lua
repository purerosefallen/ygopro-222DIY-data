--崩坏第一女主角 琪亚娜
function c75646061.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c75646061.lcheck)
	c:EnableReviveLimit()
	--specialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75646061)
	e1:SetCost(c75646061.spcost)
	e1:SetTarget(c75646061.sptg)
	e1:SetOperation(c75646061.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(75646061,ACTIVITY_SPSUMMON,c75646061.counterfilter)
	--specialSummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646061,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75646061)
	e2:SetCost(c75646061.spcost)
	e2:SetTarget(c75646061.sptg1)
	e2:SetOperation(c75646061.spop1)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(75646061,ACTIVITY_SPSUMMON,c75646061.counterfilter)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646061.chaincon)
	e4:SetOperation(c75646061.chainop)
	c:RegisterEffect(e4)
end
function c75646061.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2c0)
end
function c75646061.counterfilter(c)
	return c:IsSetCard(0x2c0) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c75646061.thcfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToGraveAsCost()
end
function c75646061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(75646061,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c75646061.thcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646061.thcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75646061.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646061.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2c0) and c:IsLocation(LOCATION_EXTRA)
end
function c75646061.filter(c,e,tp)
	return c:IsSetCard(0x32c0) and c:IsType(TYPE_EQUIP) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,0x21,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT)
end
function c75646061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646061.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75646061.spop(e,tp,eg,ep,ev,re,r,rp)   
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646061.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tg=g:GetFirst()
	if tg then
		tg:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(tg,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_WARRIOR)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_LIGHT)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(1000)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1000)
		tg:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(4)
		tg:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	end
end
function c75646061.filter1(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646061.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646061.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75646061.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646061.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75646061.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646061.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646061.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end		
	end
end
function c75646061.chainlm(e,rp,tp)
	return tp==rp
end