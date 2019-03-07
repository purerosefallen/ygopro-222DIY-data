--Servant-阿尔托莉雅
function c24420004.initial_effect(c)
	c:EnableReviveLimit()
	--return to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24420004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c24420004.thtg)
	e1:SetOperation(c24420004.thop)
	c:RegisterEffect(e1)
	
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24420004,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c24420004.destg)
	e4:SetOperation(c24420004.desop)
	c:RegisterEffect(e4)
end
function c24420004.thfilter(c)
	return c:IsCode(24420002) and c:IsAbleToHand()
end
function c24420004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24420004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420004.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24420004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c24420004.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c24420004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24420004.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c24420004.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c24420004.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c24420004.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.Destroy(g,REASON_EFFECT)
end