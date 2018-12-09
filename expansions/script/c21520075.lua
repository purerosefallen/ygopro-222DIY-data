--玲珑术-昭
function c21520075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520075,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520075.actcon)
	e1:SetCost(c21520075.cost)
	e1:SetTarget(c21520075.target)
	e1:SetOperation(c21520075.activate)
	c:RegisterEffect(e1)
end
function c21520075.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21520075.filter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_SPELLCASTER)
end
function c21520075.thfilter(c,code)
	return c:IsSetCard(0x5495) and not c:IsCode(code)
end
function c21520075.spfilter(c,e,tp,code1,code2)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x495) and not c:IsCode(code1,code2)
end
function c21520075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c21520075.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		return g:CheckWithSumEqual(Card.GetLevel,6,2,2) and Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
	local g=Duel.GetMatchingGroup(c21520075.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,2,2)
	sg:KeepAlive()
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(sg)
end
function c21520075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520075.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520075.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=e:GetLabelObject()
	local tc=rg:GetFirst()
	local code1=tc:GetCode()
	local tc2=rg:GetNext()
	local code2=tc2:GetCode()
	local g=Duel.GetMatchingGroup(c21520075.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(21520075,1))
			and Duel.IsExistingMatchingCard(c21520075.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code1,code2) then
			Duel.ConfirmCards(1-tp,sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=Duel.SelectMatchingCard(tp,c21520075.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code1,code2)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
