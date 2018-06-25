--绝界行
function c33330025.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x556))
	c:RegisterEffect(e2)   
	--lock draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(33330025,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c33330025.drcon)
	e7:SetTarget(c33330025.drtg)
	e7:SetOperation(c33330025.drop)
	c:RegisterEffect(e7)
end
function c33330025.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33330025.tdfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x556) and c:IsAbleToDeck()
end
function c33330025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330025.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c33330025.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c33330025.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33330025.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return end
	if Duel.SendtoDeck(g,1-tp,0,REASON_EFFECT)==0 then return end
	local sg=Duel.GetOperatedGroup()
	for tc in aux.Next(sg) do
		if tc:IsLocation(LOCATION_DECK) then 
		   tc:ReverseInDeck()
		end
	end
end

