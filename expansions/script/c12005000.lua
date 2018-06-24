--原罪机械 核心
function c12005000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12005000)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12005000.spcon)
	e1:SetTarget(c12005000.sptg)
	e1:SetOperation(c12005000.spop)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005000,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12005000.cost)
	e1:SetTarget(c12005000.thtg)
	e1:SetOperation(c12005000.thop)
	c:RegisterEffect(e1)
end
function c12005000.spfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c12005000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12005000.spfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c12005000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12005000.filter(c)
	return c:IsSetCard(0xfbc) and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function c12005000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c12005000.filter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	   if Duel.SelectYesNo(tp,aux.Stringid(12005000,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c12005000.filter,tp,LOCATION_HAND,0,1,1,nil)
		tc=g:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
			local e4_4=tc:GetActivateEffect()
			e4_4:SetProperty(0,EFFECT_FLAG2_COF)
			e4_4:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
			e4_4:SetCondition(c12005000.con4_4)
			tc:RegisterFlagEffect(12005000,RESET_EVENT+0x1fe0000,0,1)
			local e4_5=Effect.CreateEffect(c)
			e4_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4_5:SetCode(EVENT_ADJUST)
			e4_5:SetOperation(c12005000.op4_5)
			e4_5:SetLabelObject(tc)
			Duel.RegisterEffect(e4_5,tp)
	   end
	 end
end
function c12005000.con4_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c12005000.op4_5(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(12005000)~=0 then return end
	local e4_5_1=tc:GetActivateEffect()
	e4_5_1:SetProperty(nil)
	e4_5_1:SetHintTiming(0)
	e4_5_1:SetCondition(aux.TRUE)
	e:Reset()   
end
function c12005000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function c12005000.thfilter(c)
	return c:IsSetCard(0xfb0) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c12005000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12005000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12005000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12005000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
