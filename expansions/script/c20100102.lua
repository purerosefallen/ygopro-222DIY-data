--ReLive-Shiori
local m=20100102
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    Cirn9.ReLink(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()   
    --Change Atk
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cirn9.sap2)
    e1:SetTarget(cm.atktg)
    e1:SetOperation(cm.atkop)
    c:RegisterEffect(e1) 
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(cm.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --Recover
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.cltg)
    e3:SetOperation(cm.clop)
    c:RegisterEffect(e3) 
    cm.ClimaxAct=e3
end
function cm.matfilter(c)
    return c:IsLinkSetCard(0xc99) and not c:IsLinkCode(m)
end
function cm.rfilter(c,atk)
    return c:GetAttack()==atk
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if chk==0 then return g:GetClassCount(Card.GetAttack)>=2 end 
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(cm.rfilter,nil,g1:GetFirst():GetAttack())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g2=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xc99)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if g:GetCount()~=2 then return end
    local tc1=g:GetFirst()
    local tc2=g:GetNext()
    local atk1=tc1:GetAttack()
    local atk2=tc2:GetAttack()
    if atk1==atk2 then return end
    if atk1>atk2 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(atk2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc1:RegisterEffect(e1)
    elseif atk1<atk2 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(atk1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc2:RegisterEffect(e1)
    end
    local atk3=tc1:GetAttack()
    local atk4=tc2:GetAttack()
    if (atk3==atk4) then
        Duel.BreakEffect()
        c:AddCounter(0xc99,2)
    end
end
function cm.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_MZONE,0,1,nil) end
    local rec=Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_MZONE,0,nil)*600
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end

function cm.clfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end

function cm.clop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local rec=Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_MZONE,0,nil)*600
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rec,REASON_EFFECT)
end