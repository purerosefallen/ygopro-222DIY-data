--双色的轮舞
function c12008023.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008023,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12008023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12008023.spcost)
	e1:SetTarget(c12008023.sptg)
	e1:SetOperation(c12008023.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008023,4))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12008123)
	e2:SetTarget(c12008023.thtg)
	e2:SetOperation(c12008023.thop)
	c:RegisterEffect(e2)  
end
function c12008023.cfilter(c)
	return c:IsSetCard(0x1fb3) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c12008023.thfilter2(c)
	return c:IsSetCard(0x2fb3) and c:IsAbleToHand() and not c:IsCode(12008023)
end
function c12008023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008023.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local mg=Duel.SelectMatchingCard(tp,c12008023.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,mg)
	e:SetLabelObject(mg:GetFirst())
end
function c12008023.sptg(e,tp,eg,ep,ev,re,r,rp,chk,mg)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12008023.spop(e,tp,eg,ep,ev,re,r,rp,mg)
	local cg=e:GetLabelObject()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12008023,1))
		local tg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		local atk1=tg:GetFirst():GetAttack()
		local atk2=cg:GetAttack()
		if atk1>=atk2 then return end
		 local ts=Duel.GetMatchingGroup(c12008023.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	   if ts:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008023,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local tg2=ts:Select(tp,1,1,nil)
		  Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg2)
	   end
	  Duel.BreakEffect()
	  if not Duel.SelectYesNo(tp,aux.Stringid(12008023,3))  then return end
	   Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	   Duel.Destroy(tg,REASON_EFFECT) 
	   Duel.ShuffleHand(tp)
	   Duel.ShuffleHand(1-tp)
	end
end
function c12008023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c12008023.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x47e0000)
		e4:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e4,true)  
end

