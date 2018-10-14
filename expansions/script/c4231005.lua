--群星的仪式-梦幻召唤
local m=4231005
local cm=_G["c"..m]
cm.fit_monster={4231004}
function cm.initial_effect(c)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_ACTIVATE)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
            if chk==0 then 
                local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
                return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
                    and ((ft>-1 and Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil,ft))
                      or (ft>0 and Duel.IsExistingMatchingCard(cm.mfilter,tp,0,LOCATION_MZONE,1,nil,ft)))
            end
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.SetChainLimit(aux.FALSE) end end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
            local tc=tg:GetFirst()
            if tc then
                if ft>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft)
                else
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
                end
                tc:SetMaterial(mat)
                Duel.ReleaseRitualMaterial(mat)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
                tc:CompleteProcedure()
            end end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(m,0))
        .e("SetCategory",CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_IGNITION)
        .e("SetRange",LOCATION_GRAVE)
        .e("SetCountLimit",1,m)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
            Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
            Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
            if g:GetCount()>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g)
                local mg=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
                if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
                    if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
                        Duel.BreakEffect()
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                        local sg=mg:Select(tp,1,1,nil)
                        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                    end
                end
            end
        end)
    .Return())
end
function cm.cfilter(c,e,tp) 
    return c:IsCode(4231004) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.cfilter2(c,e,tp) 
    return c:IsCode(4231000) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end
function cm.thfilter(c) 
    return c:IsCode(4231004) and c:IsAbleToHand() 
end
function cm.mfilter(c,ft) 
    return      c:GetEquipGroup():IsExists(function(c) return c:IsCode(4231006) end,1,nil) 
            and c:GetEquipGroup():IsExists(function(c) return c:IsCode(4231007) end,1,nil) 
            and (not((c:GetSequence()==5 or c:GetSequence()==6)and ft<=0) or ft>0)
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end
