--新绿的淑女·高垣枫
function c81009014.initial_effect(c)
	c:SetSPSummonOnce(81009014)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c81009014.ovfilter,aux.Stringid(81009014,0))
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81009014)
	e1:SetCondition(c81009014.dacon)
	e1:SetCost(c81009014.dacost)
	e1:SetOperation(c81009014.daop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81009914)
	e2:SetTarget(c81009014.tdtg)
	e2:SetOperation(c81009014.tdop)
	c:RegisterEffect(e2)
end
function c81009014.ovfilter(c)
	return c:IsFaceup() and c:IsCode(81009011)
end
function c81009014.dafilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c81009014.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
		and Duel.IsExistingMatchingCard(c81009014.dafilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end
function c81009014.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81009014.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c81009014.dafilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c81009014.tdfilter(c)
	return c:IsType(TYPE_XYZ+TYPE_LINK) and c:IsAbleToExtra()
end
function c81009014.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81009014.tdfilter(chkc) and chkc:IsAbleToExtra() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(c81009014.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81009014.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c81009014.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
