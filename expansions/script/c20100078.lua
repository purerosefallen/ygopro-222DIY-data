--ReLive-Tamao
local m=20100078
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)     
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.retg)
    e2:SetOperation(cm.reop)
    c:RegisterEffect(e2) 
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.thtg1)
    e3:SetOperation(cm.thop1)
    c:RegisterEffect(e3) 
    cm.ClimaxAct=e3 
end
function cm.filter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsLevel(5)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT) then
            Duel.ConfirmCards(1-tp,g)
            if e:GetHandler():IsRelateToEffect(e) then
                Duel.BreakEffect()
                c:AddCounter(0xc99,1)
                if Duel.GetFlagEffect(tp,m)~=0 then return end
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(m,3))
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetTargetRange(LOCATION_HAND,0)
                e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
                e1:SetTarget(aux.TargetBoolFunction(Card.IsLevel,5))
                e1:SetValue(0x1)
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_EXTRA_SET_COUNT)
                Duel.RegisterEffect(e2,tp)
                Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            end
        end  
    end
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0xc99,1)
    --summon with 1 tribute
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetDescription(aux.Stringid(m,4))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetTargetRange(LOCATION_HAND,0)
    e2:SetCode(EFFECT_SUMMON_PROC)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.otcon)
    e2:SetTarget(cm.ottg)
    e2:SetOperation(cm.otop)
    e2:SetValue(SUMMON_TYPE_ADVANCE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_SET_PROC)
    Duel.RegisterEffect(e3,tp)
end
function cm.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg,1-tp) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function cm.ottg(e,c)
    return c:IsLevel(5)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    local sg=Duel.SelectTribute(tp,c,1,1,mg,1-tp)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.clfilter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_DECK,0,nil)
    if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local g=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg2=g:Select(tp,1,1,nil)
    tg1:Merge(tg2)
    if tg1:GetCount()>0 then
        Duel.SendtoHand(tg1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg1)
    end    
end