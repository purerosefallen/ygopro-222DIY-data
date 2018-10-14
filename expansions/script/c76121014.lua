--于森之长空的翱翔
function c76121014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76121014)
	e1:SetTarget(c76121014.tgtg)
	e1:SetOperation(c76121014.tgop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121014,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,76121114)
	e2:SetCost(c76121014.cost)
	e2:SetTarget(c76121014.settg)
	e2:SetOperation(c76121014.setop)
	c:RegisterEffect(e2)
end
function c76121014.fufilter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c76121014.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp,c:GetOriginalAttribute())
end
function c76121014.tgfilter(c,e,tp,eg,ep,ev,re,r,rp,att)
	local te=c[c]
	if te and c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att and c:IsAbleToGrave() then 
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
		return true
	else return false end
end
function c76121014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c76121014.fufilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76121014.fufilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c76121014.fufilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c76121014.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76121014.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,tc:GetOriginalAttribute())
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local sc=g:GetFirst()
		local te=sc[sc]
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c76121014.cfilter(c)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c76121014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76121014.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c76121014.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c76121014.setfilter(c)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(76121014) and c:IsSSetable()
end
function c76121014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76121014.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76121014.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c76121014.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end