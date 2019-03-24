--STS遗物·燃烧之血
function c107898201.initial_effect(c)
	c:SetUniqueOnField(1,0,107898201)
	--self destroy
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_SELF_DESTROY)
	e0:SetCondition(c107898201.sdcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c107898201.target)
	e1:SetOperation(c107898201.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c107898201.eqlimit)
	c:RegisterEffect(e2)
	--lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(107898201,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c107898201.lptg)
	e4:SetOperation(c107898201.lpop)
	c:RegisterEffect(e4)
	--equip search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(107898201,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c107898201.thcost)
	e6:SetTarget(c107898201.thtg)
	e6:SetOperation(c107898201.thop)
	c:RegisterEffect(e6)
end
function c107898201.sdfilter(c)
	return c:IsCode(107898203) and c:IsFaceup()
end
function c107898201.sdcon(e)
	return Duel.IsExistingMatchingCard(c107898201.sdfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c107898201.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898201.eqfilter1(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c107898201.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898201.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c107898201.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c107898201.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c107898201.eqlimit(e,c)
	return c:IsCode(107898101)
end
function c107898201.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c107898201.lpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c107898201.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c107898201.thfilter(c,ec)
	return c:IsSetCard(0x575d) and not c:GetCode()~=107898201 and c:IsAbleToHand() and c:CheckEquipTarget(ec)
end
function c107898201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c107898201.thfilter,tp,LOCATION_DECK,0,1,nil,ec) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c107898201.thop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c107898201.thfilter,tp,LOCATION_DECK,0,1,1,nil,ec)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end