--幻层驱动 导流层
function c10130007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10130007.target1)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10130007.posop)
	c:RegisterEffect(e2)
	--Pos Change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_POSITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c10130007.target)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e5)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa336))
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10130007,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10130007.drcon)
	e4:SetTarget(c10130007.drtg)
	e4:SetOperation(c10130007.drop)
	c:RegisterEffect(e4)
	if not c10130007.global_check then
		c10130007.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHANGE_POS)
		ge1:SetOperation(c10130007.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c10130007.target(e,c)
	return c:IsSetCard(0xa336) and c:IsFaceup()
end
function c10130007.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d:IsControler(tp) then a=d end
	return a:IsSetCard(0xa336) 
end
function c10130007.psfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa336) and c:IsControler(tp) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsCanTurnSet()
end
function c10130007.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local sg=g:Filter(c10130007.psfilter,nil,tp)
	if sg:GetCount()>=0 then
	   Duel.Hint(HINT_CARD,0,10130007)
	   if Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)~=0 then
		  local dg=Duel.GetMatchingGroup(c10130007.ssfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.ShuffleSetCard(dg)
	   end
	end
end
function c10130007.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c10130007.drcon(e,tp,eg,ep,ev,re,r,rp) and c10130007.drtg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetOperation(c10130007.drop)
		c10130007.drtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:GetHandler():RegisterFlagEffect(10130007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10130007.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xa336) then
		   Duel.RegisterFlagEffect(tc:GetControler(),10130007,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c10130007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10130007)~=0 and e:GetHandler():GetFlagEffect(10130007)==0
end
function c10130007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c10130007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==1 then
		Duel.ShuffleHand(p)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
function c10130007.efilter(c)
	return (c:IsFaceup() and c:IsSetCard(0xa336)) or c:IsFacedown()
end
function c10130007.econ(e)
	return Duel.IsExistingMatchingCard(c10130007.efilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c10130007.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10130007.repfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and not c:IsHasEffect(EFFECT_CANNOT_CHANGE_POS_E) and c:IsSetCard(0xa336)
end
function c10130007.repval2(e,c)
	return c10130007.repfilter2(c,e:GetHandlerPlayer())
end
function c10130007.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c10130007.repfilter2,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_CHANGE_POS_E) end
	local g=eg:Filter(c10130007.repfilter2,nil,tp)
	e:SetLabelObject(g)
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c10130007.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10130007)
	local g=e:GetLabelObject()
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c10130007.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanTurnSet() and c:IsSetCard(0xa336)
end
function c10130007.repval(e,c)
	return c10130007.repfilter(c,e:GetHandlerPlayer())
end
function c10130007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c10130007.repfilter,1,nil,tp) end
	local g=eg:Filter(c10130007.repfilter,nil,tp)
	e:SetLabelObject(g)
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c10130007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10130013)
	local g=e:GetLabelObject()
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
	   local sg=Duel.GetMatchingGroup(c10130007.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130007.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end