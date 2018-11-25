--Cirn9 Personal Function
Cirn9=Cirn9 or {}
--Pack 01 Toji no Miko
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
			e2_1:SetValue(800)	  --
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
			e2_1:SetValue(800)	  --
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
			e2_1:SetValue(600)	  --
			token:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_FIELD)
			e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2_2:SetTargetRange(0,1)
			e2_2:SetValue(Cirn9.smlimit)	--sm means Shidou Maki
			e2_2:SetCondition(Cirn9.smcon)
			token:RegisterEffect(e2_2) 
		end
		if code==20100028 then  --御 刀 九 字 兼 定
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(500)	  --
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
			e2_1:SetValue(500)	  --
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
			e2_1:SetValue(500)	  --Tsubakuro Yume
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
			e2_1:SetValue(700)	  --Origami Yukari
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