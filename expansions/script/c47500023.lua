--红莲之王 姬塔
function c47500023.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),3,4,c47500023.lcheck)   
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500023,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47500023.xyztg)
    e1:SetOperation(c47500023.xyzop)
    c:RegisterEffect(e1)    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500023,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47500023)
    e2:SetCondition(c47500023.thcon)
    e2:SetTarget(c47500023.thtg)
    e2:SetOperation(c47500023.thop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetOperation(c47500023.actop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e4)
end
c47500023.card_code_list={47500000}
function c47500023.lfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCode(47500000)
end
function c47500023.lcheck(g,lc)
    return g:IsExists(c47500023.lfilter,1,nil)
end
function c47500023.xyzfilter(c)
    return c:IsXyzSummonable(nil) and aux.IsCodeListed(c,47500000)
end
function c47500023.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500023.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47500023.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47500023.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=g:Select(tp,1,1,nil)
        Duel.XyzSummon(tp,tg:GetFirst(),nil)
    end
end
function c47500023.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local dg=Group.CreateGroup()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    local atk=c:GetAttack()
    local def=tc:GetBaseDefense()
    local lp=Duel.GetLP(1-tp)
    if tc:IsType(TYPE_LINK) then
        Duel.SetLP(1-tp,lp-atk)
        dg:AddCard(tc)
    end
    if atk>def and not tc:IsType(TYPE_LINK) and Duel.Damage(1-tp,atk-def,REASON_BATTLE) then
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_DEFENSE)
        e3:SetValue(-atk)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
    end
    Duel.Remove(dg,POS_FACEUP,REASON_RULE)
end
function c47500023.cfilter(c,tp)
    return c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c47500023.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47500023.cfilter,1,nil,tp)
end
function c47500023.thfilter(c)
    return c:IsCode(47500000) and c:IsAbleToHand()
end
function c47500023.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c47500023.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47500023.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47500023.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47500023.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end