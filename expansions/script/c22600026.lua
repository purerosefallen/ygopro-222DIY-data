--音乐森林—邂逅的天籁
function c22600026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22600026+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22600026.activate)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22600026,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetTarget(c22600026.rmtg1)
	e2:SetOperation(c22600026.rmop1)
	c:RegisterEffect(e2)

	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22600026,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCost(c22600026.rmcost)
	e3:SetTarget(c22600026.rmtg2)
	e3:SetOperation(c22600026.rmop2)
	c:RegisterEffect(e3)
end

function c22600026.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x260) and c:IsAbleToHand()
end

function c22600026.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c22600026.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c22600026.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(tp)
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end

function c22600026.rmfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToRemove()
end

function c22600026.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	if e:GetLabel()==0 then 
		g=Duel.SelectMatchingCard(1-tp,c22600026.rmfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	elseif 
		e:GetLabel()==1 then g=Duel.SelectMatchingCard(1-tp,c22600026.rmfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	else
		g=Duel.SelectMatchingCard(1-tp,c22600026.rmfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP) 
	end
	if g:GetCount()~=0 then
		Duel.ConfirmCards(tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c22600026.filter(c,lv)
	return c:IsSetCard(0x260) and c:GetLevel()==lv and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function c22600026.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,1)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,2)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,3)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,4)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,5)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,6)
		and Duel.IsExistingMatchingCard(c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,7) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g5=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g6=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,6)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g7=Duel.SelectMatchingCard(tp,c22600026.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,7)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	g1:Merge(g6)
	g1:Merge(g7)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c22600026.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end

function c22600026.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
