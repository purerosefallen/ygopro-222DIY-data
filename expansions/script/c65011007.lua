--时终结
function c65011007.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65011007,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65011007.thcon)
	e1:SetCost(c65011007.thcost)
	e1:SetTarget(c65011007.thtg1)
	e1:SetOperation(c65011007.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(65011007,1))
	e2:SetTarget(c65011007.thtg2)
	e2:SetOperation(c65011007.thop2)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(65011007,2)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,65011007)
	e3:SetTarget(c65011007.target)
	e3:SetOperation(c65011007.activate)
	c:RegisterEffect(e3)
end

function c65011007.chanfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) 
end

function c65011007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65011007.chanfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65011007.chanfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c65011007.chanfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c65011007.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

function c65011007.thcofil(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION)
end

function c65011007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65011007.thcofil,1,nil) 
end
function c65011007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RegisterFlagEffect(65011007,RESET_CHAIN,0,1)
end
function c65011007.thfilter2(c)
	return c:IsSetCard(0xda2) and c:IsAbleToHand()
end
function c65011007.thfilter1(c)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65011007.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0xda2) and Duel.IsExistingMatchingCard(c65011007.thfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and e:GetHandler():GetFlagEffect(65011007)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c65011007.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011007.thfilter2,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(65011007)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65011007.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0xda2)
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65011007.thfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c65011007.thop2(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65011007.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
end