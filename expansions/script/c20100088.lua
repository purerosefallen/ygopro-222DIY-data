--ReLive-Shizuha
local m=20100088
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    --move
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.mvtg)
    e1:SetOperation(cm.mvop)
    c:RegisterEffect(e1)    
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(Cirn9.ap2)
    e2:SetOperation(cm.reop)
    c:RegisterEffect(e2) 
    --attach
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(Cirn9.clcost)
    e3:SetCondition(Cirn9.clcon)
    e3:SetTarget(cm.xtg)
    e3:SetOperation(cm.xop)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.mvfilter(c)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0xc99) and c:IsFaceup()
end
function cm.addfilter(c)
    return c:IsSetCard(0xc99) and c:IsType(TYPE_MONSTER)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
    e:GetHandler():AddCounter(0xc99,1)
    Duel.SelectTarget(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local a1=tc:GetSequence()
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
    local a2=tc:GetSequence()
    if a1~=a2 then
        if Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_DECK,0,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
                Duel.BreakEffect()
                local add=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_DECK,0,1,1,nil)
                Duel.Overlay(tc,add)
            end
        end
    end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0xc99,1)
    if Duel.GetFlagEffect(tp,m)~=0 then return end
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.xfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xc99)
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.xfilter(chkc) and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(cm.xfilter,tp,LOCATION_MZONE,0,1,c) 
        and (Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<1 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
        Duel.Overlay(tc,g)
    end
end