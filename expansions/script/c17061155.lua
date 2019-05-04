--
local m=17061155
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side1=m+1
cm.dfc_back_side2=m+2
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--reborn preparation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY+LOCATION_SZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY+LOCATION_SZONE)
	e2:SetCondition(cm.accon)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,nil,0,0)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return e:GetHandler():GetFlagEffect(m)>9
	and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	e:SetLabel(op)
	if op==0 then
	local tcode=e:GetHandler().dfc_back_side1
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	else
	local tcode1=e:GetHandler().dfc_back_side2
	e:GetHandler():SetEntityCode(tcode1,true)
	e:GetHandler():ReplaceEffect(tcode1,0,0)
	end
end