--混沌形态·朱丽叶
function c1160203.initial_effect(c)
--
	aux.AddXyzProcedure(c,aux.FALSE,1,2,c1160203.filter,aux.Stringid(1160203,0))
	c:SetSPSummonOnce(1160203)
	c:EnableReviveLimit()
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetOperation(c1160203.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c1160203.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1160203,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1160203.con4)
	e4:SetTarget(c1160203.tg4)
	e4:SetOperation(c1160203.op4)
	c:RegisterEffect(e4)
--
end
--
function c1160203.filter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:GetAttack()>399
end
--
function c1160203.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d and d~=c and Duel.Destroy(d,REASON_EFFECT)~=0 then
		c:RegisterFlagEffect(1160203,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		if c:GetFlagEffect(1160203)>2 then return end
		Duel.ChainAttack()
	end
end
--
function c1160203.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return end
	local c=e:GetHandler()
	c:RegisterFlagEffect(1160204,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(1160205,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
--
function c1160203.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(1160204)~=c:GetFlagEffect(1160205)
end
--
function c1160203.tfilter4(c,gn)
	local g=c:GetColumnGroup()
	local checknum=0
	if gn:GetCount()>0 then
		local tc=gn:GetFirst()
		while tc do
			if g:IsContains(tc) then checknum=1 end
			tc=gn:GetNext()
		end
	end
	return checknum==0 and c:IsDestructable() and not c:IsLocation(LOCATION_FZONE)
end
function c1160203.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gn=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160203.tfilter4,tp,0,LOCATION_ONFIELD,1,nil,gn) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c:GetAttack())
end
--
function c1160203.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gn=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1160203.tfilter4,tp,0,LOCATION_ONFIELD,1,1,nil,gn)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local seq=tc:GetSequence()
	if seq>4 then seq=seq==5 and 1 or 3 end
	Duel.MoveSequence(c,4-seq)
	Duel.BreakEffect()
	Duel.Destroy(tc,REASON_EFFECT)
	Duel.Damage(1-tp,c:GetAttack(),REASON_EFFECT)
end
--
