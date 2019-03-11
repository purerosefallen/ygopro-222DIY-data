--空之特异点 姬塔
function c47551000.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,3,3,c47551000.lcheck)     
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47551000,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47551000)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47551000.batcon)
    e1:SetTarget(c47551000.battg)
    e1:SetOperation(c47551000.batop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47551000,0))
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47551000.drcon)
    e2:SetTarget(c47551000.drtg)
    e2:SetOperation(c47551000.drop)
    c:RegisterEffect(e2)
    --cannot be target/battle indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetTarget(c47551000.tgtg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    c:RegisterEffect(e4)    
    local e5=e3:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)
end
function c47551000.lcheck(g)
    return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c47551000.batcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c47551000.filter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47551000.battg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c47551000.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47551000.batop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47551000.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=Duel.GetFirstTarget()
    local bc=g:GetFirst()
    if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.CalculateDamage(tc,bc) 
    end
end
function c47551000.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=eg:GetFirst()
    return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsFaceup() and rc:IsType(TYPE_PENDULUM) and rc:IsControler(tp)
end
function c47551000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47551000.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)~=0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end
function c47551000.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end