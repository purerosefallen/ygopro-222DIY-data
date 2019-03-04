--Cirn9 Personal Function    
Cirn9=Cirn9 or {}      --Welcome my firend~
--Pack 01 Toji no Miko is on the line 5
--Pack 02 Shoujyo Kageki ReLive is on the line 460
function Cirn9.TojiEquip(ec,code,e,tp,eg,ep,ev,re,r,rp)
    local token=Duel.CreateToken(tp,code)
    Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    token:CancelToGrave()
    local e1_1=Effect.CreateEffect(token)
    e1_1:SetType(EFFECT_TYPE_SINGLE)
    e1_1:SetCode(EFFECT_CHANGE_TYPE)
    e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
    e1_1:SetReset(RESET_EVENT+0x1fc0000)
    token:RegisterEffect(e1_1,true)
    local e1_2=Effect.CreateEffect(token)
    e1_2:SetType(EFFECT_TYPE_SINGLE)
    e1_2:SetCode(EFFECT_EQUIP_LIMIT)
    e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1_2:SetValue(1)
    token:RegisterEffect(e1_2,true)
    token:CancelToGrave()   
    if Duel.Equip(tp,token,ec,false) then 
        if code==20100002 then  --御 刀 加 州 清 光
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(300)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetCategory(CATEGORY_ATKCHANGE)
            e2_2:SetType(EFFECT_TYPE_IGNITION)
            e2_2:SetCode(EVENT_FREE_CHAIN)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetCost(Cirn9.amcost)  --am means Asakura Mihono
            e2_2:SetOperation(Cirn9.amop)
            token:RegisterEffect(e2_2)
        end
        if code==20100004 then  --御 刀 骚 速 之 剑
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
            e2_1:SetValue(500)
            token:RegisterEffect(e2_1) 
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
            e2_2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetTargetRange(LOCATION_MZONE,0)
            e2_2:SetTarget(Cirn9.sclimit) --sc means Setouchi Chie 
            e2_2:SetValue(aux.tgoval)
            token:RegisterEffect(e2_2)   
        end
        if code==20100006 then  --御 刀 北 谷 菜 切  二 王 清 纲
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(500)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)  --Shichinosato Kofuki
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_ADD_TYPE)
            e2_2:SetValue(TYPE_TUNER)
            token:RegisterEffect(e2_2)
        end
        if code==20100008 then  --御 刀 莲 华 不 动 辉 广
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(200)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
            e2_2:SetValue(200)
            token:RegisterEffect(e2_2)
            local e2_3=Effect.CreateEffect(ec)
            e2_3:SetCategory(CATEGORY_RECOVER)
            e2_3:SetType(EFFECT_TYPE_IGNITION)
            e2_3:SetRange(LOCATION_SZONE)
            e2_3:SetCountLimit(1)
            e2_3:SetTarget(Cirn9.mktg)  --mk means Musumi Kiyoka
            e2_3:SetOperation(Cirn9.mkop)
            token:RegisterEffect(e2_3)  
        end
        if code==20100011 then  --御 刀 实 休 光 忠 
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(400)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
            e2_2:SetValue(400)
            token:RegisterEffect(e2_2)  
            local e2_3=Effect.CreateEffect(ec)
            e2_3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
            e2_3:SetType(EFFECT_TYPE_IGNITION)
            e2_3:SetCode(EVENT_FREE_CHAIN)
            e2_3:SetProperty(EFFECT_FLAG_CARD_TARGET)
            e2_3:SetRange(LOCATION_SZONE)
            e2_3:SetCost(Cirn9.amcost)
            e2_3:SetTarget(Cirn9.kmtg)  --km means Kitora Mirja
            e2_3:SetOperation(Cirn9.kmop)
            token:RegisterEffect(e2_3)   
        end
        if code==20100013 then  --御 刀 千 鸟
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(500)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_QUICK_O)
            e2_2:SetCode(EVENT_FREE_CHAIN)
            e2_2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
            e2_2:SetProperty(EFFECT_FLAG_CARD_TARGET)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_BATTLE_START)
            e2_2:SetCost(Cirn9.amcost)
            e2_2:SetCondition(Cirn9.ekcon)
            e2_2:SetTarget(Cirn9.ektg)  --ek means Etou Kanami
            e2_2:SetOperation(Cirn9.ekop)
            token:RegisterEffect(e2_2)   
        end
        if code==20100015 then  --御 刀 孙 六 兼 元 
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(300)
            token:RegisterEffect(e2_1)
            --Activate
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
            e2_2:SetType(EFFECT_TYPE_QUICK_O)
            e2_2:SetCode(EVENT_ATTACK_ANNOUNCE)
            e2_2:SetCost(Cirn9.amcost)
            e2_2:SetCondition(Cirn9.ymcon)  --ym means Yanase Mai
            e2_2:SetTarget(Cirn9.ymtg)
            e2_2:SetOperation(Cirn9.ymop)
            token:RegisterEffect(e2_2)
        end  
        if code==20100017 then  --御 刀 小 乌 丸 
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(400)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_DIRECT_ATTACK)
            e2_2:SetCondition(Cirn9.jhcon)  --jh means Jujo Hiyori
            token:RegisterEffect(e2_2)
        end
        if code==20100019 then  --御 刀 妙 法 村 正
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(400)
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_QUICK_O)
            e2_2:SetCode(EVENT_FREE_CHAIN)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetCost(Cirn9.amcost) 
            e2_2:SetOperation(Cirn9.isop)   --is means Itomi Sayaka
            token:RegisterEffect(e2_2)
        end
        if code==20100021 then  --御 刀 弥 弥 切 丸
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(800)  --
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)  
            e2_2:SetCode(EFFECT_PIERCE)
            token:RegisterEffect(e2_2)
        end
        if code==20100024 then  --御 刀 越 前 康 继
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
            e2_1:SetValue(800)  --
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_FIELD)
            e2_2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetTargetRange(0,LOCATION_MZONE)
            e2_2:SetValue(Cirn9.kalimit1)   --ka means Kohagura Eren
            token:RegisterEffect(e2_2)
            local e2_3=Effect.CreateEffect(ec)
            e2_3:SetType(EFFECT_TYPE_FIELD)
            e2_3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
            e2_3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e2_3:SetRange(LOCATION_SZONE)
            e2_3:SetTargetRange(LOCATION_MZONE,0)
            e2_3:SetTarget(Cirn9.kalimit2)
            e2_3:SetValue(aux.tgoval)
            token:RegisterEffect(e2_3)
        end
        if code==20100026 then  --御 刀 薄 绿
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(600)  --
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_FIELD)
            e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetCode(EFFECT_CANNOT_ACTIVATE)
            e2_2:SetTargetRange(0,1)
            e2_2:SetValue(Cirn9.smlimit)    --sm means Shidou Maki
            e2_2:SetCondition(Cirn9.smcon)
            token:RegisterEffect(e2_2) 
        end
        if code==20100028 then  --御 刀 九 字 兼 定
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(500)  --
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
            e2_2:SetCode(EVENT_BATTLE_DAMAGE)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetCost(Cirn9.amcost)
            e2_2:SetCondition(Cirn9.kscon)  --ks means konohana Suzuka
            e2_2:SetOperation(Cirn9.ksop)
            token:RegisterEffect(e2_2)
        end
        if code==20100030 then  --御 刀 水 神 切 兼 光
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(500)  --
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_FIELD)
            e2_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetTargetRange(LOCATION_SZONE,0)
            e2_2:SetTarget(Cirn9.sytg)  --sy means Satsuki Yomi
            e2_2:SetValue(1)
            token:RegisterEffect(e2_2)
        end
        if code==20100032 then  --御 刀 笑 面 青 江
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(500)  --Tsubakuro Yume
            token:RegisterEffect(e2_1)
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_EQUIP)
            e2_2:SetCode(EFFECT_ATTACK_ALL)
            e2_2:SetValue(1)
            token:RegisterEffect(e2_2)
        end
        if code==20100035 then  --御 刀 童 子 切 安 纲
            local e2_1=Effect.CreateEffect(ec)
            e2_1:SetType(EFFECT_TYPE_EQUIP)
            e2_1:SetCode(EFFECT_UPDATE_ATTACK)
            e2_1:SetValue(700)  --Origami Yukari
            token:RegisterEffect(e2_1)  
            local e2_2=Effect.CreateEffect(ec)
            e2_2:SetType(EFFECT_TYPE_SINGLE)
            e2_2:SetRange(LOCATION_SZONE)
            e2_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
            e2_2:SetCode(EFFECT_LINK_SPELL_KOISHI)
            e2_2:SetValue(LINK_MARKER_TOP)
            token:RegisterEffect(e2_2) 
        end
    return true
    else Duel.SendtoGrave(token,REASON_RULE) return false
    end
end
function Cirn9.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    local syk=e:GetHandler():GetEquipTarget()
    e:SetLabelObject(syk)
    Duel.Release(e:GetHandler(),REASON_COST)
end

function Cirn9.amfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc90)
end

function Cirn9.amop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Cirn9.amfilter,tp,LOCATION_MZONE,0,nil)
    local c=e:GetHandler()
    local uc=sg:GetFirst()
    while uc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(300)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        uc:RegisterEffect(e1)
        uc=sg:GetNext()
    end
end

function Cirn9.sclimit(e,c)
    return c:IsSetCard(0xc90) and c~=e:GetHandler():GetEquipTarget()
end
function Cirn9.mkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc90)
end
function Cirn9.mktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rec=Duel.GetMatchingGroupCount(Cirn9.mkfilter,tp,LOCATION_MZONE,0,nil)*400
    if chk==0 then return rec>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function Cirn9.mkop(e,tp,eg,ep,ev,re,r,rp)
    local rec=Duel.GetMatchingGroupCount(Cirn9.mkfilter,tp,LOCATION_MZONE,0,nil)*400
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rec,REASON_EFFECT)
end
function Cirn9.kmfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsSetCard(0xc90)
end
function Cirn9.kmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and Cirn9.kmfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(Cirn9.kmfilter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Cirn9.kmfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function Cirn9.kmop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function Cirn9.ekcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function Cirn9.ektg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function Cirn9.ekop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
        if Duel.GetTurnPlayer()==tp then
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_EFFECT)
            e3:SetValue(RESET_TURN_SET)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end
function Cirn9.ymcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function Cirn9.ymtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
    local dam=tg:GetAttack()
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
    Duel.SetChainLimit(Cirn9.ymchainlm)
end
function Cirn9.ymchainlm(e,rp,tp)
    return tp==rp
end
function Cirn9.ymop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.Destroy(tc,REASON_EFFECT) then
            Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
        end
    end
end
function Cirn9.jhcon(e)
    local cg=e:GetHandler():GetEquipTarget():GetColumnGroup():Filter(Card.IsControler,nil,1-e:GetHandlerPlayer())
    return cg:FilterCount(Card.IsType,nil,TYPE_MONSTER)==0
end


function Cirn9.isop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetLabelObject()
    if tc then
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(Cirn9.efilter)
    e4:SetOwnerPlayer(tp)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e4)
    end
end
function Cirn9.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function Cirn9.kalimit1(e,c)
    return c:IsFaceup() and c:IsSetCard(0xc90) and c~=e:GetHandler():GetEquipTarget()
end
function Cirn9.kalimit2(e,c)
    return c:IsSetCard(0xc90) and c~=e:GetHandler():GetEquipTarget()
end
function Cirn9.smlimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function Cirn9.smcon(e)
    local tc=e:GetHandler():GetEquipTarget()
    return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function Cirn9.kscon(e,tp,eg,ep,ev,re,r,rp,chk)
    return ep~=tp and (Duel.GetAttacker()==e:GetHandler():GetEquipTarget() or Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget())
end
function Cirn9.ksop(e,tp,eg,ep,ev,re,r,rp)
    local lp=Duel.GetLP(1-tp)
    if lp>=1500 then Duel.SetLP(1-tp,lp-1500) else Duel.SetLP(1-tp,0) end   
end
function Cirn9.sytg(e,c)
    return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xc91)
end







--Add Butaishoujyo Property to ReLive Monster
function Cirn9.ReLiveMonster(c)
    c:EnableCounterPermit(0xc99)
    --attack cost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_COST)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCost(Cirn9.rlcost)
    e1:SetOperation(Cirn9.rlop)
    c:RegisterEffect(e1)
    --Play music <Hoshi No Dialogue> at the first turn
    if not Cirn9.global_check1 then
        Cirn9.global_check1=true
        local ge1=Effect.GlobalEffect()
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge1:SetCondition(Cirn9.opcon)
        ge1:SetOperation(Cirn9.opop)
        Duel.RegisterEffect(ge1,0)
    end
end

--ReLive field magic can not be setted
function Cirn9.ReLiveStage(c)
    if not Cirn9.global_check2 then
        Cirn9.global_check2=true
        local ge=Effect.GlobalEffect()
        ge:SetType(EFFECT_TYPE_FIELD)
        ge:SetCode(EFFECT_CANNOT_SSET)
        ge:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        ge:SetTargetRange(1,1)
        ge:SetTarget(Cirn9.stg)
        Duel.RegisterEffect(ge,0)
    end 
    --Activate without operation
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(20100108,1))
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(Cirn9.nanacon2)
    e2:SetOperation(Cirn9.stageop)
    c:RegisterEffect(e2)
end

function Cirn9.ReLink(c)
    --link
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(20100098)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_ONFIELD)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(Cirn9.linktg)
    c:RegisterEffect(e1)
end
function Cirn9.linktg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function Cirn9.ffilter(c,tp)
    return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsSetCard(0xc99)
end

--Activate ReliveStage or Not
function Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if not fc and not Duel.IsExistingMatchingCard(Cirn9.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) then return 0 end
    if not fc then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20100060,4))
        local tc=Duel.SelectMatchingCard(tp,Cirn9.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local te=tc:GetActivateEffect()
            te:UseCountLimit(tp,1,true)
            local tep=tc:GetControler()
            local cost=te:GetCost()
            if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
            return 1
        end
    end
    if fc then 
        if not Duel.IsExistingMatchingCard(Cirn9.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) then return 2 end
        if Duel.SelectYesNo(tp,aux.Stringid(20100060,5)) then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20100060,4))
            local tc=Duel.SelectMatchingCard(tp,Cirn9.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
            if tc then
                Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                local te=tc:GetActivateEffect()
                te:UseCountLimit(tp,1,true)
                local tep=tc:GetControler()
                local cost=te:GetCost()
                if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
                Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
                return 1
            end
        end
        return 2
    end
end

function Cirn9.rlcost(e,c,tp)
    local fa=Duel.GetFlagEffect(tp,20100050)    --Copy From THC Makai Deck
    local fb=Duel.GetFlagEffect(tp,20100051)    --Thanks Hiragi Sama
    local fc=fa-fb
    return (fc<6) or (e:GetHandler():GetFlagEffect(20100070)~=0)
end
function Cirn9.rlop(e,tp,eg,ep,ev,re,r,rp)
    if (e:GetHandler():GetFlagEffect(20100070)>0) then return end       
    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local rd=6-fa+fb
    if e:GetHandler():IsOriginalSetCard(0xc99) then
        Debug.Message("ReLive卡行动次数剩余"..rd.."次  DA☆ZE")
    end
end
 
function Cirn9.opcon(e)
    return Duel.GetTurnCount() == 1
end
function Cirn9.opop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(11,0,aux.Stringid(20100060,3))
end

function Cirn9.ap1(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local fc=fa-fb
    if chk==0 then return fc<6 end
    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    local rd=5-fc
    Debug.Message("ReLive卡行动次数剩余"..rd.."次  DA☆ZE")
end
function Cirn9.ap2(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local fc=fa-fb
    if chk==0 then return fc<5 end
    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    local rd=4-fc
    Debug.Message("ReLive卡行动次数剩余"..rd.."次  DA☆ZE")
end
function Cirn9.fumiap2(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local fc=fa-fb
    if chk==0 then return fc<5 or (e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and fc<6) end
    if e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    else
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    end
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
end
function Cirn9.stg(e,c)
    return c:IsSetCard(0xc99) and c:IsType(TYPE_FIELD)
end
function Cirn9.clcon(e,tp,eg,ep,ev,re,r,rp)
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if not fc and not Duel.IsExistingMatchingCard(Cirn9.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) then return false end
    return true
end
function Cirn9.clcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xc99,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xc99,3,REASON_COST)
end
function Cirn9.RevueBgm(tp)
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    local fcode=fc:GetOriginalCode()
    Duel.Hint(11,0,aux.Stringid(fcode,0))
end
function Cirn9.GetLine(c)
    if c:IsLocation(LOCATION_FZONE) then return 99  end
    if c:IsLocation(LOCATION_SZONE) then return 1   end
    if c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then return 2 end
    if c:IsLocation(LOCATION_MZONE) and c:GetSequence()>4 then return 3 end
end
function Cirn9.fap1(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local f1=Duel.GetFlagEffect(tp,20100088)
    local f2=Duel.GetFlagEffect(tp,20100089)
    local fc=fa-fb
    local f3=f1-f2
    if chk==0 then return (fc<6 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) or (f3>0) end
    if fc<6 then
        if f3<1 then 
            Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1) 
            e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
        elseif f3>0 then
            if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
                if Duel.SelectYesNo(tp,aux.Stringid(20100088,3)) then
                    Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                else
                    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1) 
                    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
                end
            else
                Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)  
            end
        end
    else
        Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1) 
    end
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
end
                    
function Cirn9.arrap1(e,tp,eg,ep,ev,re,r,rp,chk)
    local og=e:GetHandler():GetOverlayGroup()
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local f1=Duel.GetFlagEffect(tp,20100088)
    local f2=Duel.GetFlagEffect(tp,20100089)
    local fc=fa-fb
    local f3=f1-f2
    if chk==0 then return (fc<6 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0) or (f3>0) end
    if fc<6 then
        if f3<1 then 
            Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1) 
            local g=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
            Duel.Remove(g,POS_FACEUP,REASON_COST)
        elseif f3>0 then
            if og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 then
                if Duel.SelectYesNo(tp,aux.Stringid(20100088,3)) then
                    Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                else
                    Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1) 
                    local g=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
                    Duel.Remove(g,POS_FACEUP,REASON_COST)
                end
            else
                Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
                Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)  
            end
        end
    else
        Duel.RegisterFlagEffect(tp,20100089,RESET_PHASE+PHASE_END,0,1) 
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1) 
    end
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
end

function Cirn9.rlink(c)
    return c:IsType(TYPE_LINK) or (c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)) and c:IsSetCard(0xc99) and c:IsFaceup()
end

function Cirn9.sap2(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,20100050)
    local fb=Duel.GetFlagEffect(tp,20100051)
    local fc=fa-fb
    local rls=0
    local lg=e:GetHandler():GetLinkedGroup()
    if lg:IsExists(Card.IsSetCard,1,nil,0xc99)  then rls=1 end
    if e:GetHandler():IsHasEffect(20100098) then rls=1 end
    if chk==0 then return (fc<5 or((rls==1) and (fc<6))) end
    if (rls==1) then
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    else
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100050,RESET_PHASE+PHASE_END,0,1)
    end
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
end
function Cirn9.IsReLinkState(c)
    if c:IsHasEffect(20100098) then return true end
    if c:GetLinkedGroup():IsExists(Card.IsSetCard,1,nil,0xc99) then return true end
    return false
end
function Cirn9.nanacon1(e,tp,eg,ep,ev,re,r,rp)
    return (Duel.GetFlagEffect(tp,20100068)==0)
end
function Cirn9.nanacon2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return (Duel.GetFlagEffect(tp,20100068)~=0) end
end
function Cirn9.stageop(e,tp,eg,ep,ev,re,r,rp)
    Cirn9.RevueBgm(tp)
end
function Cirn9.FinishAct(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(20100108,3))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCost(Cirn9.finalcost)
    e1:SetCountLimit(1)
    e1:SetCondition(Cirn9.finalcon)
    return e1
end
function Cirn9.finalcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function Cirn9.finalcon(e,tp,eg,ep,ev,re,r,rp)
    local tid=e:GetHandler():GetTurnID()
    return (Duel.GetTurnCount()==tid+1)
end