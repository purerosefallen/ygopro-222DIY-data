--调停者的使命 佐伊
local m=17050001
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x170,LOCATION_PZONE+LOCATION_MZONE)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(cm.setcon)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--Add counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17050001,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(cm.con)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(cm.efilter)
	e6:SetCondition(cm.effcon)
	e6:SetLabel(1)
	c:RegisterEffect(e6)
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(17050001,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetLabel(3)
	e7:SetCondition(cm.effcon)
	e7:SetTarget(cm.remtg)
	e7:SetOperation(cm.remop)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetTargetRange(1,1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetLabel(5)
	e8:SetCondition(cm.effcon)
	e8:SetValue(cm.efilter)
	c:RegisterEffect(e8)
	--atk/def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(cm.atkval)
	e9:SetCondition(cm.effcon)
	e9:SetLabel(8)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	e10:SetValue(cm.defval)
	c:RegisterEffect(e10)
	--immune
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetRange(LOCATION_PZONE)
    e11:SetTargetRange(LOCATION_ONFIELD,0)
	e11:SetCondition(cm.effcon)
	e11:SetLabel(3)
    e11:SetTarget(cm.etarget)
    e11:SetValue(cm.eefilter)
    c:RegisterEffect(e11)
end
function cm.otfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_SZONE,0,nil)
	return minc<=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=3
		or Duel.CheckTribute(c,1) and mg:GetCount()>=2
		or Duel.CheckTribute(c,2) and mg:GetCount()>=1
		or Duel.CheckTribute(c,3))
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_SZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local ct=3
	while mg:GetCount()>0 and (ct>2 and Duel.CheckTribute(c,ct-2) or ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
		and (not Duel.CheckTribute(c,ct) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=mg:Select(tp,1,1,nil)
		g:Merge(g1)
		mg:Sub(g1)
		ct=ct-1
	end
	if g:GetCount()<3 then
		local g2=Duel.SelectTribute(tp,c,3-g:GetCount(),3-g:GetCount())
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.setcon(e,c,minc)
	if not c then return true end
	return false
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x170,1)
	end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x170)>=e:GetLabel()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>=0
end
function cm.atkval(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED):Filter(cm.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.deffilter(c)
	return c:IsFaceup() and c:GetDefense()>=0
end
function cm.defval(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED):Filter(cm.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function cm.etarget(e,c)
    return c:IsType(TYPE_PENDULUM)
end
function cm.eefilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end