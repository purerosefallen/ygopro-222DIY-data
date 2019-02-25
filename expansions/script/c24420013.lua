--羁绊礼装-鬼使神毒酒
function c24420013.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24420013,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24420013.target)
	e1:SetOperation(c24420013.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c24420013.eqlimit)
	c:RegisterEffect(e4)
	--search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24420013,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(c24420013.thcost)
    e2:SetTarget(c24420013.thtg)
    e2:SetOperation(c24420013.thop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SET_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    c:RegisterEffect(e3)
	
end

function c24420013.eqlimit(e,c)
	return c:IsCode(24420012)
end
function c24420013.filter(c)
	return c:IsFaceup() and c:IsCode(24420012)
end
function c24420013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24420013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24420013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c24420013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c24420013.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c24420013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c24420013.thfilter(c)
    return c:IsCode(24420012) and c:IsAbleToHand()
end
function c24420013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c24420013.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420013.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetFirstMatchingCard(c24420013.thfilter,tp,LOCATION_DECK,0,nil)
    if tg then
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end
