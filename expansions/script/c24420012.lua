--Servant-酒吞童子
function c24420012.initial_effect(c)
		c:EnableReviveLimit()
	--return to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24420012,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c24420012.thtg)
	e1:SetOperation(c24420012.thop)
	c:RegisterEffect(e1)	
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24420012,1))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
    e4:SetCost(c24420012.spcost)
	e4:SetTarget(c24420012.cttg)
	e4:SetOperation(c24420012.ctop)
	c:RegisterEffect(e4)
	
end

function c24420012.thfilter(c)
	return c:IsCode(24420002) and c:IsAbleToHand()
end
function c24420012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24420012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420012.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24420012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c24420012.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c24420012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c24420012.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c24420012.costfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c24420012.ctfilter(c)
	return c:IsAttack(0) and c:IsControlerCanBeChanged()
end
function c24420012.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c24420012.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24420012.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c24420012.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c24420012.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end