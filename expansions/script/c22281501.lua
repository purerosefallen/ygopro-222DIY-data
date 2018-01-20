--晶石之祈愿
--------The way of builtin name Is Adapted From c14141006.lua By 卡 莲  From YGOPro 222DIY--------
local m=22281501
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c22280020") end,function() require("script/c22280020") end)
cm.named_with_Spar=true
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--gaineffect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.operation)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	e:SetLabel(ct)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabelObject() then
		local sum=e:GetLabelObject():GetLabel()
		if sum>1 then
			--effect gain1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(cm.efilter1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,0))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetRange(LOCATION_FZONE)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(cm.etarget1)
			e2:SetLabelObject(e1)
			c:RegisterEffect(e2,true)
			if sum>3 then
				--cannot be target
				local e4=Effect.CreateEffect(c)
				e4:SetDescription(aux.Stringid(m,1))
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e4:SetRange(LOCATION_FZONE)
				e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e4:SetTargetRange(LOCATION_ONFIELD,0)
				e4:SetCondition(cm.immcon)
				e4:SetTarget(cm.etarget2)
				e4:SetValue(cm.tgvalue)
				c:RegisterEffect(e4)
			end
		end
	end
end
function cm.etarget1(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsStatus(STATUS_CHAINING)
end
function cm.efilter1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetAttribute()~=e:GetHandler():GetAttribute()
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<2 and e:GetHandler():IsFaceup()
end
function cm.etarget2(e,c)
	return c:IsFaceup()
end