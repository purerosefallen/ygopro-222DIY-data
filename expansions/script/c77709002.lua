local m=77709002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
        local function cf(c)
            return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
        end
        if chk==0 then return Duel.IsExistingMatchingCard(cf,tp,0,LOCATION_GRAVE,1,nil) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local g=Duel.SelectMatchingCard(tp,cf,tp,0,LOCATION_GRAVE,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_COST)
    end)
    local function f(c,tp)
        return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_MZONE) or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1)
    end
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
            and #g>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,#g+1,nil)
        end
        local tg=Duel.GetMatchingGroup(f,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#g+1,tp,LOCATION_GRAVE)
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
        if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
            local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
            Duel.BreakEffect()
            local ct=Duel.SendtoGrave(tg,REASON_EFFECT+REASON_DISCARD)
            if ct>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
                local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,ct+1,ct+1,nil)
                if #sg>0 then
                    Duel.BreakEffect()
                    Duel.HintSelection(sg)
                    Duel.SendtoHand(sg,nil,REASON_EFFECT)
                end
            end
        end
    end)
    c:RegisterEffect(e1)
end
