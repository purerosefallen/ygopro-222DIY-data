--STSE·毒药研究室
function c107898603.initial_effect(c)
	c:EnableReviveLimit()
	--damage&atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(107898603,0))
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c107898603.dmgcon)
	e3:SetTarget(c107898603.dmgtg)
	e3:SetOperation(c107898603.dmgop)
	c:RegisterEffect(e3)
	--damage to all
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c107898603.regop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(107898603,0))
	e4:SetCategory(CATEGORY_DAMAGE+EFFECT_UPDATE_ATTACK+EFFECT_UPDATE_DEFENSE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c107898603.damcon)
	e4:SetTarget(c107898603.damtg)
	e4:SetOperation(c107898603.damop)
	e4:SetLabelObject(e0)
	c:RegisterEffect(e4)
end
function c107898603.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c107898603.damfilter(c)
	return c:GetCounter(0x1009)>0
end
function c107898603.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,0,0x1009)>0 or Duel.IsExistingMatchingCard(c107898603.damfilter,tp,0,LOCATION_MZONE,1,nil) end
	if Duel.GetCounter(tp,1,0,0x1009)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetCounter(tp,1,0,0x1009)*100)
	end
end
function c107898603.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCounter(tp,1,0,0x1009)>0 then
		Duel.Damage(1-tp,Duel.GetCounter(tp,1,0,0x1009)*100,REASON_EFFECT)
		Duel.RemoveCounter(tp,1,0,0x1009,1,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c107898603.damfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc~=nil do
			if tc:GetAttack()>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(-tc:GetCounter(0x1009)*100)
				tc:RegisterEffect(e1)
			end
			tc:RemoveCounter(tp,0x1009,1,REASON_EFFECT)
			if tc:IsAttack(0) then
				Duel.Destroy(tc,REASON_EFFECT)
			end
			tc=g:GetNext()
		end
	end
end
function c107898603.cfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetCounter(0x11)>0 and c:GetControler()~=tp
end
function c107898603.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c107898603.cfilter,1,nil) then
		local ec=eg:GetFirst()
		local dam=0
		while ec~=nil do
			if ec:IsLocation(LOCATION_ONFIELD) and ec:GetCounter(0x11)>0 and ec:GetBaseAttack()>0 then
				dam=dam+ec:GetBaseAttack()
			end
			ec=eg:GetNext()
		end
		e:SetLabel(dam)
	else e:SetLabel(0) end
end
function c107898603.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>0
end
function c107898603.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabelObject():GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabelObject():GetLabel())
end
function c107898603.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(-d)
			sc:RegisterEffect(e1)
			if sc:IsAttack(0) then
				Duel.Destroy(sc,REASON_EFFECT)
			end
			sc=g:GetNext()
		end
	end
end