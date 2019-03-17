--带来光明者 路西欧
local m=17010302
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
    aux.EnablePendulumAttribute(c)
	--immune
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_IMMUNE_EFFECT)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(LOCATION_MZONE,0)
    e0:SetTarget(cm.etarget)
    e0:SetValue(cm.eefilter)
    c:RegisterEffect(e0)
	--to deck
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.epcon)
    e1:SetTarget(cm.eptg)
    e1:SetOperation(cm.epop)
    c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--TO HAND
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.thcon)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	--chain attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(aux.bdocon)
	e5:SetOperation(cm.atop)
	c:RegisterEffect(e5)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_HAND)
	e7:SetCondition(cm.hspcon)
	e7:SetOperation(cm.hspop)
	c:RegisterEffect(e7)
end
function cm.etarget(e,c)
    return c:IsType(TYPE_PENDULUM)
end
function cm.eefilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return te:GetOwner()~=e:GetOwner()
end
function cm.epcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.epop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
    end
end
function cm.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PENDULUM)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(eg:Filter(cm.thfilter,nil),nil,REASON_EFFECT)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    Duel.ChainAttack()
end
function cm.spfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:IsReleasable()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.Release(g1,REASON_COST)
end