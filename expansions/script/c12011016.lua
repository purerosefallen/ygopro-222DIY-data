--黑姬的养成所
function c12011016.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12011016,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12011016.rmtg)
	e1:SetOperation(c12011016.rmop)
	c:RegisterEffect(e1)   
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12011016,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c12011016.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetDescription(aux.Stringid(12011016,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCost(c12011016.cost2)
	e5:SetTarget(c12011016.tg2)
	e5:SetOperation(c12011016.op2)
	c:RegisterEffect(e5)
end
function c12011016.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rg,2,0,0)
end
function c12011016.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c12011016.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb5)
end
function c12011016.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c12011016.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c12011016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function c12011016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c12011016.tgfilter1(c)
	return c:IsAbleToDeck()
end
function c12011016.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SortDecktop(tp,tp,1)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(12011016,3)) then
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c12011016.tgfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		end
	end
end