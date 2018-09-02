--外身化形 天刃
function c65020017.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65020017,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c65020017.condition)
	e1:SetTarget(c65020017.target)
	e1:SetOperation(c65020017.activate)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65020017.tgtg)
	e2:SetOperation(c65020017.tgop)
	c:RegisterEffect(e2)
end

function c65020017.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_MZONE)
end
function c65020017.thfil(c,typ)
	return c:IsType(typ) and c:IsAbleToHand()
end
function c65020017.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local typ=0
		if tc:IsType(TYPE_MONSTER) then typ=TYPE_MONSTER end
		if tc:IsType(TYPE_SPELL) then typ=TYPE_SPELL end
		if tc:IsType(TYPE_TRAP) then typ=TYPE_TRAP end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65020017.thfil,tp,LOCATION_DECK,0,1,nil,typ) and Duel.SelectYesNo(tp,aux.Stringid(tp,65020017,2)) then
			local g=Duel.SelectMatchingCard(tp,c65020017.thfil,tp,LOCATION_DECK,0,1,1,nil,typ)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c65020017.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c65020017.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c65020017.cfilter,1,nil,tp) 
end
function c65020017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil)
	local b2=Duel.IsChainNegatable(ev)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65020017,0),aux.Stringid(65020017,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(65020017,0))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65020017,1))
	else return end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65020017,op))
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
	end
end
function c65020017.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local ec=re:GetHandler()
		if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
			Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)
		end
	end
	if op==0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c65020017.repop)
	end
end
function c65020017.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(1-tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end