--秋樱之风乘载的回忆
function c1150017.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1150017.con1)
	e1:SetTarget(c1150017.tg1)
	e1:SetOperation(c1150017.op1)
	c:RegisterEffect(e1)
	if c1150017.check==nil then
		c1150017.check=true
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_1:SetCode(EVENT_DAMAGE)
		e1_1:SetOperation(c1150017.op1_1)
		Duel.RegisterEffect(e1_1,0)
	end
--  
end
--
function c1150017.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,1150017,RESET_PHASE+PHASE_END,0,2)
	Duel.RegisterFlagEffect(ep,1150050,RESET_PHASE+PHASE_END,0,1)
end
--
function c1150017.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1150017)~=Duel.GetFlagEffect(tp,1150050)
end
--
function c1150017.tfilter1(c)
	return (c:GetPreviousLocation()==LOCATION_GRAVE or c:GetPreviousLocation()==LOCATION_REMOVED) and c:IsAbleToDeck()
end
function c1150017.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(c1150017.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1150017.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_ONFIELD)
end
--
function c1150017.ofilter1(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1150017.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1150017.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c1150017.ofilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(1150017,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1150017.ofilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1,true)
			end
		end
	end
end







