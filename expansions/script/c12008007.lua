--孤高的拒绝，波恋达斯
function c12008007.initial_effect(c)
	 --disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c12008007.disop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008007,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(2,12008007)
	e2:SetCondition(c12008007.thcon)
	e2:SetTarget(c12008007.thtg)
	e2:SetOperation(c12008007.thop)
	c:RegisterEffect(e2)
end
function c12008007.thfilter(c)
	return c:IsSetCard(0x1fb3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12008007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12008007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12008007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,g)
	   if Duel.GetFlagEffect(tp,12008006)<=0 then return end
	   local tg=Duel.GetMatchingGroup(c12008007.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	   if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008007,0)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local tg2=tg:Select(tp,1,1,nil)
		  Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg2)
	   end 
	end
end
function c12008007.thfilter2(c)
	return c:IsCode(12008006) and c:IsAbleToHand()
end
function c12008007.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c12008007.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)~=1 then return end
	Duel.NegateEffect(ev)
end