--ReLiveStage-Ayapatrol
local m=20100114
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m-6,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)   
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    --finish act
    local e3=Cirn9.FinishAct(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --Search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCountLimit(1)
    e4:SetCondition( cm.secon)
    e4:SetTarget(cm.setg)
    e4:SetOperation(cm.seop)
    c:RegisterEffect(e4)
    cm.FinishAct=e3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0x10)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Cirn9.RevueBgm(tp)
    if not Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,nil) then return end
    local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
    return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end

function cm.thfilter(c,code)
    return c:IsAbleToHand() and c:IsSetCard(0xc99) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
end
function cm.sefilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xc99) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
        and c:IsControler(tp)
end
function cm.secon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.sefilter,1,nil,tp) and eg:GetCount()==1 and Duel.GetTurnPlayer()==1-tp
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local spc=eg:GetFirst()
    if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,spc:GetCode()) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,spc:GetCode())
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function cm.desfilter(c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local sg=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
    if sg:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
    else
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
    end
end
function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.fa1(c,tp)
    local cg=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)
    return cg>0 and c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    local mtg=Duel.GetMatchingGroupCount(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
    local clg=Duel.GetMatchingGroup(cm.fa1,tp,LOCATION_MZONE,0,nil,tp)
    local sg=Group.CreateGroup()
    local sg1=Group.CreateGroup()
    if mtg>0 then
        sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
        Duel.HintSelection(sg)
    else
        if clg:GetCount()<1 then return 
        else sg=Duel.SelectMatchingCard(tp,cm.fa1,tp,LOCATION_MZONE,0,1,1,nil,tp)
            sg1=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,1,1,sg:GetFirst())
            sg:Merge(sg1)
            Duel.HintSelection(sg)
        end
    end
    Duel.BreakEffect()
    local c=e:GetHandler()
    local fc=sg:GetFirst()
    local sc=sg:GetNext()
    local dg=Group.CreateGroup()
    local g1=fc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
    if g1:GetCount()>0 then dg:Merge(g1) end
    local g2=sc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
    if g2:GetCount()>0 then dg:Merge(g2) end
    local g3=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
    if g3:GetCount()>0 then dg:Merge(g3) end
    if dg:GetCount()>0 then Duel.Destroy(dg,REASON_EFFECT) end
end