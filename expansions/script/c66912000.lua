--Unicorn Gundam
local m=66912000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetCountLimit(1,m)
	e1:SetValue(1)
	c:RegisterEffect(e1)  
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(cm.spcons)
	e2:SetCountLimit(1,m)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.aclimit)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(cm.actcon)
	e4:SetValue(1500)
	c:RegisterEffect(e4)  
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.tgcon)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5) 
	--control
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.tgcon)
	e6:SetTarget(cm.tgtg)
	e6:SetOperation(cm.tgop)
	c:RegisterEffect(e6)  
	--link material 
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e7:SetValue(1)
	c:RegisterEffect(e7) 
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.filters(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0
end
function cm.spcons(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.filters,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_LINK) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.actcon(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsType(TYPE_LINK)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(66912003)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAbleToChangeControler() and c:GetMutualLinkedGroupCount()>0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return not e:IsActiveType(TYPE_LINK) and e:IsActiveType(TYPE_MONSTER)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.GetControl(sg,tp,PHASE_END,1)>0 then
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD)
		   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		   e1:SetTargetRange(1,0)
		   e1:SetTarget(cm.splimit)
		   e1:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e1,tp) 
		end
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_LINK) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end