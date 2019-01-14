--炎帝・パーシヴァル
--granbluefantasy.jp
local m=47500507
local cm=_G["c"..m]
function cm.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,false)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(cm.fpcon)
    e0:SetOperation(cm.fpop)
    c:RegisterEffect(e0)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetCondition(cm.immcon)
    e1:SetValue(cm.efilter)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetOperation(cm.atkop)
    c:RegisterEffect(e2)
end
function cm.matfilter(c,fc)
    return c:IsCanBeFusionMaterial(fc) and c:IsRace(RACE_WARRIOR)
end
function cm.spfilter(c,fc)
    return cm.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function cm.spfilter1(c,tp,g)
    return g:IsExists(cm.spfilter2,1,c,tp,c)
end
function cm.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function cm.fpcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(cm.fselect,1,nil,tp,mg,sg)
end
function cm.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(cm.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function cm.fpop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,cm.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function cm.immcon(e)
    return Duel.GetAttacker()==e:GetHandler() 
    and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-1
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct*400)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e1)
end

