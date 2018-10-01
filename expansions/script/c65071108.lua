--伪善
function c65071108.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071108,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65071108.drtg)
	e1:SetOperation(c65071108.drop)
	c:RegisterEffect(e1)
	 --cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c65071108.discon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65071108,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c65071108.recon)
	e5:SetTarget(c65071108.retg)
	e5:SetOperation(c65071108.reop)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c65071108.imcon)
	e6:SetValue(c65071108.efilter)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_INACTIVATE)
	c:RegisterEffect(e7)
end

function c65071108.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

function c65071108.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	e:GetHandler():AddCounter(0x10da,1)
end

function c65071108.discon(e,c)
	return e:GetHandler():GetCounter(0x10da)>0
end

function c65071108.imcon(e,c)
	return e:GetHandler():GetCounter(0x10da)>=4 
end

function c65071108.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c65071108.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x10da)>=5 and Duel.GetTurnPlayer()~=tp 
end
function c65071108.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,0)
end
function c65071108.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
			local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
			local rg=Duel.GetDecktopGroup(1-tp,ct)
			if rg:GetCount()>0 then
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
	Duel.BreakEffect()
	local num=c:GetCounter(0x10da)
	c:RemoveCounter(tp,0x10da,num,REASON_EFFECT)
end