--时终语的沉迷者
function c65011003.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65011003)
	e1:SetCondition(c65011003.thcon)
	e1:SetTarget(c65011003.thtg)
	e1:SetOperation(c65011003.thop)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,65011003)
	e2:SetCost(c65011003.discost)
	e2:SetTarget(c65011003.distg)
	e2:SetOperation(c65011003.disop)
	c:RegisterEffect(e2)
end
function c65011003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c65011003.filter(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
end
function c65011003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65011003.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65011003.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65011003,0))
	Duel.SelectTarget(tp,c65011003.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c65011003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or (tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)<1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if tc:IsControler(tp) then
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end

function c65011003.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65011003.disfilter(c)
	return c:IsSetCard(0xda2) and c:IsAbleToGrave()
end
function c65011003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011003.disfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c65011003.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65011003.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end