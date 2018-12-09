--极寒灵龙
function c21520093.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520093,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21520093.discon)
	e1:SetTarget(c21520093.distg)
	e1:SetOperation(c21520093.disop)
	c:RegisterEffect(e1)
	--frozen
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520093,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21520093.atkcon)
	e2:SetTarget(c21520093.atktg)
	e2:SetOperation(c21520093.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21520093.indes)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e3_1=e3:Clone()
	e3_1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3_1)
	--def down
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c21520093.dcon)
	e4:SetOperation(c21520093.dop)
	c:RegisterEffect(e4)
end
function c21520093.disfilter(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and not c:IsDisabled() and c:IsFaceup()
end
function c21520093.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c21520093.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c21520093.dislimit)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,LOCATION_SZONE)
end
function c21520093.dislimit(e,ep,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c21520093.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520093.disfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			--disable
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				--disable trap monster
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
			end
			tc=g:GetNext()
		end
	end
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c21520093.aclimit)
	e2:SetCondition(c21520093.actcon)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c21520093.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c21520093.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c21520093.atkfilter(e,c)
	return e:GetHandler():IsRelateToCard(c) --c:GetFlagEffect(21520093)~=0
end
function c21520093.valcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	return rc:IsFaceup() and rc:IsOnField() and e:GetHandler():IsRelateToCard(rc) and rc:GetFlagEffect(21520093)~=0
end
function c21520093.atkval(e,c)
	local atk=c:GetTextAttack()
	if atk<0 then atk=0 end
	return atk
end
function c21520093.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c21520093.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c21520093.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		c:CreateRelation(tc,RESET_EVENT+0x1ff0000)
--		c:RegisterFlagEffect(21520093,RESET_EVENT+0xdff0000,0,1)
		tc:RegisterFlagEffect(21520093,RESET_EVENT+0xdfe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c21520093.valcon)
		e1:SetTarget(c21520093.atkfilter)
		e1:SetValue(c21520093.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		Duel.RegisterEffect(e1,tp)--]]
----[[		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD)
		e0:SetLabelObject(tc)
		e0:SetOperation(c21520093.resetop)
		c:RegisterEffect(e0)
	end
end
function c21520093.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabelObject()
	if rc:GetFlagEffect(21520093)==0 then
		c:ReleaseRelation(rc)
	end
	if not c:IsRelateToCard(rc) then
		rc:ResetFlagEffect(21520093)--]]
	end
end
function c21520093.indes(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetDefense()>0 and c:IsFaceup()
end
function c21520093.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520093.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(-400)
	c:RegisterEffect(e1)
end
