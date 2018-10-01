--星辰钟塔的玛利亚
function c11200099.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11200098,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,true,true)  
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200099,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetCost(c11200099.negcost)
	e1:SetTarget(c11200099.negtg)
	e1:SetOperation(c11200099.negop)
	c:RegisterEffect(e1)  
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c11200099.aclimit)
	e2:SetCondition(c11200099.actcon)
	c:RegisterEffect(e2)
	--ad
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c11200099.actcon)
	e3:SetValue(c11200099.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c11200099.damcon)
	e5:SetOperation(c11200099.damop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11200099,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c11200099.thcon)
	e6:SetTarget(c11200099.thtg)
	e6:SetOperation(c11200099.thop)
	c:RegisterEffect(e6)
	if not c11200099.wolegemamamam then
	   c11200099.wolegemamamam=true
	   c11200099[0]=Duel.GetLP(0)
	   c11200099[1]=Duel.GetLP(1)
	end
end
function c11200099.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c11200099.thfilter(c)
	return c:IsCode(11200098) and c:IsAbleToHand()
end
function c11200099.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11200099.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function c11200099.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11200099.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,g)
	   if e:GetHandler():IsRelateToEffect(e) then
		  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	   end
	end
end
function c11200099.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c11200099.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=math.abs(c:GetAttack()-c:GetBaseAttack())
	Duel.ChangeBattleDamage(ep,math.min(val,2500))
end
function c11200099.val(e,c)
	local tp=e:GetHandlerPlayer()
	local aval=math.abs(Duel.GetLP(tp)-c11200099[tp])
	return math.min(aval,2500)
end
function c11200099.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c11200099.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c11200099.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200099.negfilter(c)
	return aux.disfilter1(c)
end
function c11200099.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11200099.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200099.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c11200099.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c11200099.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
		   local e3=e1:Clone()
		   e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		   tc:RegisterEffect(e3)
		end
	end
end