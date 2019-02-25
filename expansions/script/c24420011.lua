--羁绊礼装-玉藻俱乐部
function c24420011.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24420011,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24420011.target)
	e1:SetOperation(c24420011.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c24420011.eqlimit)
	c:RegisterEffect(e4)
	--search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24420011,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(c24420011.thcost)
    e2:SetTarget(c24420011.thtg)
    e2:SetOperation(c24420011.thop)
    c:RegisterEffect(e2)
	    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(24420011,2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c24420011.thtg2)
    e3:SetOperation(c24420011.thop2)
    c:RegisterEffect(e3)
	
end

function c24420011.eqlimit(e,c)
	return c:IsCode(24420010)
end
function c24420011.filter(c)
	return c:IsFaceup() and c:IsCode(24420010)
end
function c24420011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24420011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24420011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c24420011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c24420011.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c24420011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c24420011.thfilter(c)
    return c:IsCode(24420010) and c:IsAbleToHand()
end
function c24420011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c24420011.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420011.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetFirstMatchingCard(c24420011.thfilter,tp,LOCATION_DECK,0,nil)
    if tg then
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end

function c24420011.thfilter2(c,e,tp)
    return c:IsSetCard(0x245) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c24420011.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(c24420011.thfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c24420011.thop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
