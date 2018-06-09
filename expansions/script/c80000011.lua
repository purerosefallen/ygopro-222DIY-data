--超越者 历史探求者
local m=80000011
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=80000006
cm.afkind=6--jingao
cm.is_named_with_yvwan=1
cm.can_exchange=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --summon exchange
    Sym.yuwancf1(c)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetTarget(cm.totg)
    e5:SetOperation(cm.toop)
    c:RegisterEffect(e5)
end
function cm.tofil(c)
    return Sym.isyvwan(c) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.totg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tofil,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.toop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tofil,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetTurnID()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(cm.dfc_back_side)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:ResetFlagEffect(m)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) then
        local tcode=c.dfc_back_side
        c:SetEntityCode(tcode,true)
        c:ReplaceEffect(tcode,0,0)
        Duel.BreakEffect()
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end