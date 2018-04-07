--自由斗士·飞翔的科普
function c10131001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10131001+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10131001.ahop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131001,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10131001.destg)
	e2:SetOperation(c10131001.desop)
	c:RegisterEffect(e2) 
end
function c10131001.desfilter(c,tp)
	return c:IsSetCard(0x5338) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10131001.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c10131001.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c10131001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c10131001.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10131001.tgfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
end
function c10131001.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10131001.thfilter),tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	   if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		  Duel.Destroy(tc,REASON_EFFECT)
	   end
	end
end
function c10131001.ahfilter(c)
	return c:IsSetCard(0x5338) and c:IsAbleToHand() and not c:IsCode(10131001) and c:IsType(TYPE_MONSTER)
end
function c10131001.ahop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c10131001.ahfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10131001,0)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10131001.ahfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		  Duel.ConfirmCards(1-tp,g)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		  local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g:GetFirst())
		  Duel.Destroy(dg,REASON_EFFECT)
	   end
	end
end