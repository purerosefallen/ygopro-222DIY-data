--飞翼高达
local m=17020001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,3,3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--pendulum set/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.ddescon)
	e2:SetTarget(cm.ddestg)
	e2:SetOperation(cm.ddesop)
	c:RegisterEffect(e2)
	--atk voice
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(cm.atksuc)
    c:RegisterEffect(e3)
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_MACHINE)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thfilter(c,g)
	return g:IsContains(c)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local cg=tc:GetColumnGroup()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	g:AddCard(tc)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17020001,3))
end
function cm.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function cm.ddescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4000
end
function cm.ddestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(17020001)==0 and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	c:RegisterFlagEffect(17020001,RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.ddesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack())
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020001,2))
	end
end
function cm.atksuc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17020001,5))
    else 
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17020001,4))
    end
end