--玲珑术-韵
function c21520074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520074,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520074.actcon)
	e1:SetCost(c21520074.cost)
	e1:SetTarget(c21520074.target)
	e1:SetOperation(c21520074.activate)
	c:RegisterEffect(e1)
end
function c21520074.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21520074.filter(c,e,tp,lv)
	if lv~=nil then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x495) and c:IsLevelBelow(lv)
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x495)
	end
end
function c21520074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c21520074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
		return g:GetCount()>0 and (Duel.IsExistingMatchingCard(c21520074.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,g:GetCount()) 
		or Duel.IsExistingMatchingCard(c21520074.filter,tp,LOCATION_DECK,0,1,nil,e,tp,g:GetCount())) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520074.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c21520074.filter,tp,LOCATION_DECK,0,nil,e,tp,rg:GetCount())
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
