--异乡猎人
function c11200039.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200039,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11200039)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c11200039.pscost)
	e1:SetTarget(c11200039.pstg)
	e1:SetOperation(c11200039.psop)
	c:RegisterEffect(e1)	
	--sdasd
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200039,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,11200139)
	e2:SetCost(c11200039.drcost)
	e2:SetTarget(c11200039.drtg)
	e2:SetOperation(c11200039.drop)
	c:RegisterEffect(e2)
end
function c11200039.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c11200039.rcfilter,1,nil,tp) end
end
function c11200039.rcfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and (Duel.IsPlayerCanDraw(tp,1) or (Duel.IsExistingMatchingCard(c11200039.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsLocation(LOCATION_MZONE)))
end
function c11200039.thfilter(c)
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function c11200039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.SelectReleaseGroupEx(tp,c11200039.rcfilter,1,1,nil,tp):GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then 
		e:SetLabel(100)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Release(tc,REASON_COST)
end
function c11200039.drop(e,tp,eg,ep,ev,re,r,rp)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(c11200039.thfilter,tp,LOCATION_DECK,0,1,nil)
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(11200039,2))) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c11200039.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c11200039.cfilter(c)
	return c:IsType(TYPE_LINK) or not c:IsPosition(POS_FACEUP_DEFENSE)
end
function c11200039.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c11200039.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200039.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11200039.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if not g:GetFirst():IsType(TYPE_LINK) then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
end
function c11200039.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_LINK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
	else
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(c11200039.damcon)
	e1:SetOperation(c11200039.damop)
	e1:SetLabel(e:GetLabel())
	c:RegisterEffect(e1)
end
function c11200039.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return ep~=tp and bc and bc:IsControler(1-tp) and e:GetLabel()>bc:GetAttack()
end
function c11200039.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,11200039)
	Duel.Damage(1-tp,e:GetLabel()-bc:GetAttack(),REASON_EFFECT)
end
function c11200039.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3000)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
end