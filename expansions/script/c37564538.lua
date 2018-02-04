--Nanahira & Dazz
local m=37564538
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e22)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(m*16)
	ex:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	ex:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,0)
	ex:SetType(EFFECT_TYPE_ACTIVATE)
	ex:SetCode(EVENT_CHAINING)
	ex:SetCost(cm.desccost)
	ex:SetCondition(cm.condition2)
	ex:SetTarget(cm.target2)
	ex:SetOperation(cm.activate2)
	local ex_q=ex:Clone()
	ex_q:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(function(e,c)
		return c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and c:GetSequence()<5
	end)
	e3:SetLabelObject(ex)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(function(e,c)
		return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:GetSequence()<5
	end)
	e3:SetLabelObject(ex_q)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c.Senya_desc_with_nanahira and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	return Senya.CheckGroup(g,Senya.CheckFieldFilter,nil,3,3,tp,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,g,Senya.CheckFieldFilter,nil,3,3,tp,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.desccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if e:GetHandler():IsStatus(STATUS_SET_TURN) and (e:GetHandler():GetOriginalType() & TYPE_QUICKPLAY+TYPE_TRAP)==0 then return false end
	return (e:GetHandler():GetOriginalType() & re:GetHandler():GetOriginalType() & 0x7)~=0
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if e:IsActiveType(TYPE_CONTINUOUS) and not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) then return end
	local e1=nil
	if tc:IsType(TYPE_MONSTER) and not tc:IsHasEffect(EFFECT_MONSTER_SSET) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
	end 
	if tc:IsSSetable() then
		Duel.DisableShuffleCheck()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	elseif e1 then
		e1:Reset()
	end
end