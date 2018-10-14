--聚镒素 火风
function c10110017.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10110017.ffilter1,c10110017.ffilter2,true) 
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110017,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(LOCATION_ONFIELD+LOCATION_HAND)
	e1:SetCondition(c10110017.thcon)
	e1:SetTarget(c10110017.thtg)
	e1:SetOperation(c10110017.thop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=e1:Clone()  
	e2:SetDescription(aux.Stringid(10110017,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetTarget(c10110017.destg)
	e2:SetOperation(c10110017.desop)
	c:RegisterEffect(e2)
end
function c10110017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c10110017.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   if Duel.Destroy(g,REASON_EFFECT)~=0 then
		  Duel.Damage(1-tp,800,REASON_EFFECT)
	   end
	end
end
function c10110017.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,e:GetLabel())
end
function c10110017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10110017.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	   Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
function c10110017.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110017.ffilter3,1,nil,ATTRIBUTE_WIND))
end
function c10110017.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110017.ffilter3,1,nil,ATTRIBUTE_FIRE))
end
function c10110017.ffilter3(c,att)
	return c:IsFusionAttribute(att) and c:IsFusionSetCard(0x9332)
end