--冒险遗产的遗迹
function c18001009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18001009.target)
	e1:SetOperation(c18001009.activate)
	c:RegisterEffect(e1)  
	--eq
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetDescription(aux.Stringid(18001009,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c18001009.eqcost2)
	e3:SetTarget(c18001009.eqtg2)
	e3:SetOperation(c18001009.eqop2)
	c:RegisterEffect(e3)  
end
c18001009.setname="advency"
function c18001009.filter(c)
	return c.setname=="advency" and c:IsAbleToHand()
end
function c18001009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18001009.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18001009.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18001009.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18001009.eqcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c18001009.tgfilter(c,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsFaceup() and Duel.IsExistingMatchingCard(c18001009.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c18001009.cfilter(c)
	return c.setname=="advency" and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end
function c18001009.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c18001009.tgfilter(chkc,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c18001009.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c18001009.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c18001009.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c18001009.cfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local ec=sg:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
		   --Add Equip limit
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_EQUIP_LIMIT)
		   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e1:SetValue(c18001009.eqlimit)
		   ec:RegisterEffect(e1)
		end
	end
end
function c18001009.eqlimit(e,c)
	return e:GetOwner()==c
end