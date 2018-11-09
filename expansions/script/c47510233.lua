--真红的穿光·漆黑的大镰
local m=47510233
local cm=_G["c"..m]
function c47510233.initial_effect(c)
    aux.EnablePendulumAttribute(c) 
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47510233.ffilter,2,false) 
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47510233.spcon)
    e0:SetOperation(c47510233.spop)
    c:RegisterEffect(e0)  
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(c47510233.defop)
    c:RegisterEffect(e1) 
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCountLimit(1)
    e2:SetOperation(c47510233.atkop)
    c:RegisterEffect(e2)
    --double atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(1)
    c:RegisterEffect(e3) 
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510233.tpcon)
    e8:SetTarget(c47510233.tptg)
    e8:SetOperation(c47510233.tpop)
    c:RegisterEffect(e8) 
end
function c47510233.defop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    local dg=Group.CreateGroup()
    while tc do
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_DEFENSE)
        e3:SetValue(-1500)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.ChangePosition(dg,POS_FACEUP_DEFENSE,true)
    if tc:IsType(TYPE_LINK) then
        Duel.Remove(tc,POS_FACEDOWN,REASON_RULE)
    end
end
function c47510233.ffilter(c,fc,sub,mg,sg)
    return c:IsFusionType(TYPE_PENDULUM) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c47510233.spfilter(c,fc)
    return c47510233.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47510233.spfilter1(c,tp,g)
    return g:IsExists(c47510233.spfilter2,1,c,tp,c)
end
function c47510233.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47510233.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47510233.spfilter,nil,c)
    return g:IsExists(c47510233.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47510233.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47510233.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47510233.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47510233.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c47510233.ctfilter(c)
    return c:IsRace(RACE_MACHINE)
end
function c47510233.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then 
        local c=e:GetHandler()
        local atk=c:GetBaseAttack()
        local lp=Duel.GetLP(1-tp)
        if Duel.SetLP(1-tp,lp-atk) and Duel.SelectYesNo(tp,aux.Stringid(47510233,0)) then
        local g=Duel.GetMatchingGroup(c47510233.ctfilter,tp,0,LOCATION_MZONE,nil)
            if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
            local g1=g:Select(tp,1,1,nil)
            Duel.HintSelection(g1)
            local tc=g1:GetFirst()
                if tc then
                    Duel.GetControl(tc,tp)
                end
            end
        end
    end
end
function c47510233.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510233.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510233.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end