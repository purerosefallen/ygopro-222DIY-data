--忍妖 魔神龙
function c12017010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12017010.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c12017010.sprcon)
	e2:SetOperation(c12017010.sprop)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c12017010.tg)
	e3:SetOperation(c12017010.op)
	c:RegisterEffect(e3)

	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12017010.econ)
	e1:SetValue(c12017010.efilter)
	c:RegisterEffect(e1)
end
function c12017010.econ(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c12017010.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12017010.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c12017010.spfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end
function c12017010.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c12017010.spfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.GetLocationCountFromEx(tp)>0
end
function c12017010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12017010.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12017010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),0,0,1)
end
function c12017010.mfilter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c12017010.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(700)
		c:RegisterEffect(e1)
	mat1=g:Filter(c12017010.mfilter,nil)
	g:Sub(mat1)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
		tc=g:GetNext()
end
function c12017010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local cg=g:GetCount()
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
--  if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(700*cg)
		c:RegisterEffect(e1)
--   mat1=g:Filter(c12017010.mfilter,nil)
--   g:Sub(mat1)
--   if g:GetCount() then
--   local tc=g:GetFirst()
--   while tc do
--  local e1=Effect.CreateEffect(e:GetHandler())
--  e1:SetType(EFFECT_TYPE_SINGLE)
--  e1:SetCode(EFFECT_CANNOT_TRIGGER)
--  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
--  e1:SetReset(RESET_PHASE+PHASE_END)
--   tc:RegisterEffect(e1)
--  end
--  tc=g:GetNext()
--  end
end