--奥法术士 泽洛
Duel.LoadScript("c22280001.lua")
c22280003.named_with_Spar=true
c22280003.named_with_Zero=true
function c22280003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280003,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22280003.target)
	e1:SetOperation(c22280003.operation)
	c:RegisterEffect(e1)
	--DECK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22280003,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c22280003.tg)
	e2:SetOperation(c22280003.op)
	c:RegisterEffect(e2)
end
function c22280003.filter1(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.IsExistingMatchingCard(c22280003.filter2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute()) and c:IsReleasableByEffect()
end
function c22280003.filter2(c,att)
	return c:IsAttribute(att) and c:IsAbleToHand() and c:IsRace(RACE_ROCK) and scorp.check_set_Spar(c)
end
function c22280003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c22280003.filter1(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22280003.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22280003.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c22280003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=Duel.GetMatchingGroup(c22280003.filter2,tp,LOCATION_DECK,0,nil,tc:GetAttribute())
	if mg:GetCount()>0 then
		local g=mg:Select(tp,1,1,nil)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.Release(tc,REASON_EFFECT)
		end
	end
end
function c22280003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,0,tp,LOCATION_DECK)
end
function c22280003.filter3(c)
	return scorp.check_set_Spar(c) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c22280003.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local dg=g:Filter(c22280003.filter3,nil)
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end