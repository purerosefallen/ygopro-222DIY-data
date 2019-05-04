--顶端的芦苇原
function c1110164.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c1110164.lcheck)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1110164.con1)
	e1:SetOperation(c1110164.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110164,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1110164.con2)
	e2:SetTarget(c1110164.tg2)
	e2:SetOperation(c1110164.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110164.lfilter(c)
	return c:GetSequence()>4
end
function c1110164.lcheck(g,lc)
	return g:IsExists(c1110164.lfilter,1,nil)
end
--
function c1110164.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1110164.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1_1:SetValue(c1110164.efilter1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1_2:SetValue(c1110164.efilter1_1)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_2,tp)
end
function c1110164.efilter1_1(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return e:GetHandlerPlayer()==tp
		and tc:IsType(TYPE_MONSTER) and muxu.check_set_Urban(tc)
end
--
function c1110164.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
--
function c1110164.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
--
function c1110164.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
		local ct=Duel.GetTurnCount()
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2_1:SetLabel(ct+1)
		e2_1:SetCondition(c1110164.con2_1)
		e2_1:SetOperation(c1110164.op2_1)
		e2_1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2_1,tp)
	end
end
function c1110164.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnCount()==e:GetLabel()
end
function c1110164.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetDescription(aux.Stringid(1110164,1))
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_2:SetCode(EVENT_PHASE+PHASE_END)
	e2_2:SetLabel(ev)
	e2_2:SetCountLimit(1)
	e2_2:SetCondition(c1110164.con2_2)
	e2_2:SetOperation(c1110164.op2_2)
	e2_2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e2_2,tp)
	Duel.ChangeBattleDamage(ep,0)
end
function c1110164.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1110164.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local dlp=e:GetLabel()
	Duel.Damage(tp,dlp,REASON_EFFECT)
end
--
