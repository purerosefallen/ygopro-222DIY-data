--灾厄古兽 哥莫拉
function c14801047.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14801047,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c14801047.descon)
	e2:SetCountLimit(1,14801047)
	e2:SetTarget(c14801047.destg)
	e2:SetOperation(c14801047.desop)
	c:RegisterEffect(e2)
	--destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14801047,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,148010471)
	e3:SetCondition(c14801047.spcon)
	e3:SetCost(c14801047.spcost)
	e3:SetOperation(c14801047.spop1)
	c:RegisterEffect(e3)
	--end battle phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14801047,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,148010472)
	e4:SetCondition(c14801047.condition)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(c14801047.operation)
	c:RegisterEffect(e4)
end
function c14801047.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c14801047.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c14801047.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c14801047.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14801047.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c14801047.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14801047.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c14801047.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c14801047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0x4800) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0x4800)
	Duel.Release(g,REASON_COST)
end
function c14801047.spbfilter(c,e,tp)
	return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801047.spop1(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c14801047.spbfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801047,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g1:Select(tp,1,1,nil)
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c14801047.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c14801047.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
